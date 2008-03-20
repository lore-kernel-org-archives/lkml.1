Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYCTX4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYCTX4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYCTX4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:57106 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYCTX4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q1Wmn1enTtnEdKQagGwYspNnV902zlM+y255rSeGHQeeedcpOJD9B/plHn+AgqkBRC0xoiP2LwxSdmBhebOx1vRXUXsYeXK2SGxcpHHOBS8u2Y4V2MhUrkqVHO35FSaHcOgrHj+AA2CQzXh042ShUWk6OrdF+Xb2cRIgrwDqn2Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 01/17] ide-tape: remove unused parameter from idetape_copy_stage_to_user
Date: Thu, 20 Mar 2008 22:42:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803202242.09970.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
