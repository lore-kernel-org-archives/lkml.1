Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYJUJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYJUJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYJUJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:05:21 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:49879 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYJUJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AghY7YZ79iSoNq8cx/Udmt6xiXWXg8KJP4f8E7JPzBUKljFPAag+Wk35a/pTZqqJoq
         1fZCXpHAvjcSWGxzcSsxah6E1wgi0XaybNE9nRnGGv3TqVKI4Lrf58EfXMWJcaP40T4F
         XrH8sbDzpu4WRAPRrAyJhID1/n/BxFSET5K4I=
Message-ID: <df9815e70810210205m36a6e47di41e52776511f8ba6@mail.gmail.com>
Date: Tue, 21 Oct 2008 17:05:19 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Prabhu Chawandi" <prabhu.chavandi@gmail.com>
Subject: Re: History of Linux File !!!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <241b8f7b0810210156k27a957c3i5df40f12068ea199@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <241b8f7b0810210156k27a957c3i5df40f12068ea199@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 4:56 PM, Prabhu Chawandi
<prabhu.chavandi@gmail.com> wrote:
> Hi,
>
>  Is there any way tosee the history of a linux kernel file....
>
> I mean .. when it is updated changed or what is the latest version ...
>

try :

$ git whatchanged -p   path/to/your/file

-- 
Thanks,
Jike
