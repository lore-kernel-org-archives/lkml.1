Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbZDGVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbZDGVlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761633AbZDGVk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:40:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45110 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761485AbZDGVky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=V/A5R6B4xHccVErJvzEwvadTkbHKppmPaeClpyPYpiSdEtsgsS2uKSjwBkpTUuoACE
         P+NVObyxNQQKxkQmsLQbv3PHfMD0FNvxrodgZHpP6Xas0ZnR/OZCRGZqgzd9gV44cF7H
         GgXUaB6V/oIaKIyFsay8o3PbzPwJoaIpt40Ts=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide-cd: reverse NOT_READY sense key logic
Date: Tue, 7 Apr 2009 20:25:25 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238922962-19727-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1238922962-19727-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072025.30587.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 11:16:01 Borislav Petkov wrote:
> Make the case of flushing the drive's cache explicit.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
