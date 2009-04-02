Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbZDBXOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbZDBXOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZDBXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:14:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58915 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZDBXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ljMux7R3C1pOXv28SowOkZM3wsiTEgCK5xFr/VFGcvgLKn/VyfvbJAPWKIIGrCtY5Q
         uKNO/yvYXm90pu9dBH3PdCiSCfSm+YrOZ3MfsgjLJrAXbshe3iHlI6jM9hKz9Kjme08E
         3zj6EsloUWT0kf0U9S8m/CV0vv9TUbOCsHBKI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/3] ide-cd: move status checking into the IRQ handler
Date: Fri, 3 Apr 2009 00:42:25 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1238655519-10074-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030042.28239.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009, Borislav Petkov wrote:
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
