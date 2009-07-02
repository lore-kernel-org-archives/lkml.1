Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZGBR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZGBR5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZGBR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:57:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55914 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZGBR5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=u1wu3MGUJBhufAG8IxvjNBDbXRqp978MHg9qZ0iQV7nhkyd+/DAikYTpgB8uS2ZsJG
         OR+ZG3R114hYSIdgUZ+xsArjvXjWd55LK43oWKQVNExGNMHnuxLz99TIZLNvaJwJjI3i
         V7L5Igh7KXbzTsp67c0UcHIXpNZQdRb6MypKE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH] Staging: vt6655: s/VOID/void/
Date: Thu, 2 Jul 2009 19:46:08 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.30-next-20090617-09943-g5d77a4c; KDE/4.2.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Forest Bond <forest@alittletooquiet.net>
References: <1245520957-22234-1-git-send-email-a.beregalov@gmail.com>
In-Reply-To: <1245520957-22234-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907021946.08452.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 June 2009 20:02:37 Alexander Beregalov wrote:
> Cc: Forest Bond <forest@alittletooquiet.net>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Looks OK but (in the light of possible vt665{5,6} unification) it should be
also done for vt6656, or alternatively (which is what I would personally
prefer) delayed till more complete removal of ttype.h typedefs from vt665x.
