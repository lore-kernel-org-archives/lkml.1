Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbZDPTj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbZDPTj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZDPTjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:39:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:26215 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZDPTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SAivxjzsp6Y4pXSG1nr/nKTc/sDeQlQfFUVKFUZI/F28+sVdv3L7dS6jWCZg0WO7/T
         xc4uM14gk2w/vFmrZ/dbF/B3ho/A2g65ClL3sRkWdnO6VsSSPpgQfe0jdVC2VQjVg2B/
         oEkK3Wv4gYSaaOnS74esBYRcetVfyTOQMgNyc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Subject: Re: [PATCH 15/56] ide: Remove void casts
Date: Thu, 16 Apr 2009 21:09:00 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
References: <> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm> <49DDC670.4080904@fastmail.fm>
In-Reply-To: <49DDC670.4080904@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904162109.00496.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009 11:57:04 Jack Stone wrote:
> [Added maintainer CC]
> Jack Stone wrote:
> > Remove uneeded void casts
> >
> > Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>

applied
