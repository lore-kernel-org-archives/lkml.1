Return-Path: <linux-kernel-owner+w=401wt.eu-S2993045AbXDDTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993045AbXDDTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXDDTgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:36:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15614 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993046AbXDDTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=e5hX9rwx6wOGFS5cRN5z7n8DdYjTfHzgAidSZzgNVCYMWjG0dv0y/lHyL2PeMm030Rt2Dp7F24VvneSPTT4swkJDMM/+1OPh9qM/GHlsuSHg6vvtguROQY0duqBQFOy3a9Ijlq8HHIJK2KNwVp9QkSD9tVnGNIdWDYBQiAKG0ws=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Danny Kukawka <dkukawka@suse.de>
Subject: Re: [PATCH] ide: add "optical" to sysfs "media" attribute
Date: Wed, 4 Apr 2007 21:38:51 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200704021332.48494.dkukawka@suse.de>
In-Reply-To: <200704021332.48494.dkukawka@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704042138.52057.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 02 April 2007, Danny Kukawka wrote:

> Add "optical" to sysfs "media" attribute as already in /proc
> 
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>

applied
