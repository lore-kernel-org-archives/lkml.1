Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZFESxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZFESxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFESxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:53:20 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38868 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZFESxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Sv7RXON6rvjGi+kq0YbyRMF3Yako3ot1LXwQC6CIybTpQwnvA9aJTgTm9NABD4tNln
         5za5cQM4lHKVzjJZEuNgY1Fl9TTR3no6Ax+UWknVbPaEnJme33YVf3YFREO/uYeIlqa8
         BWWFbjB9rouwCL4xafJTDXUyz8mxOBjlIwUOk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/2] ide-tape: fix flags
Date: Fri, 5 Jun 2009 20:34:06 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090604-07237-g030af10; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906052034.06668.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 09:05:06 Borislav Petkov wrote:
> Hi Bart,
> 
> those fix a stupid flags misuse that got spotted by Jiri Slaby. Please
> pay special attention to the first patch. FWIW, those can go as hot
> fixes right away and we might catch 30-rc8 since it's not out yet.

The problem is that patches seem to be against ide-2.6.git/for-next...
