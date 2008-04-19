Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYDSU4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYDSU4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYDSUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:55:53 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:33713 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755963AbYDSUzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jZcNLJWcvCyAabVUWbtTHztP+/TFGv96Av1BYflkk5qOOueweB9ykYZ2S6JbYveLQtkN4R4i3pKdXut6hTTxLEkx7z4BrEqdho/Vv9+lpWJeUjfStbxTbnX8ERriNiepHajPgJ57lxOsb/HCGzt7Mo4xPsXp5HdzjRF3rpw7kBQ=
Message-ID: <86802c440804191355x814170el797f05a5b8fe059c@mail.gmail.com>
Date: Sat, 19 Apr 2008 13:55:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: devzero@web.de
Subject: Re: aacraid broken in git
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <245566938@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <245566938@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 2:04 AM,  <devzero@web.de> wrote:
> what was the last working kernel for you?
>  any chance to bisect ?
..
2.6.25

if no clue, will do bisect.

YH
