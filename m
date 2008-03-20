Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbYCTX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbYCTX5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYCTX4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:63085 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbYCTX4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=b8TEA+5ubKkpPQRGkHWAyylvo4HhD5bhld4Ma54ZE2yzV8zNPmJ2JZHQKfMxFIWPugUYX4/1YAaKXMy/xgVy5hJPGjxbouqbXcwRPw9jH9qNv2/iJOaBpvU0da2n02eMdvidKt0Z3mgNUuu4NcdywyJv3v+RNsULEVrka1M0q2c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/17] ide-tape: remove unused parameter from idetape_copy_stage_from_user
Date: Thu, 20 Mar 2008 22:42:21 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803202242.21159.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
