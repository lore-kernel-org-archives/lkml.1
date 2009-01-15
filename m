Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbZAON4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbZAON4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZAON4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:56:16 -0500
Received: from mail.openmoko.org ([88.198.124.205]:52999 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZAON4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:56:15 -0500
Date: Thu, 15 Jan 2009 19:25:44 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@openedhand.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/pcf50633: Terminate i2c_device_id list
Message-ID: <20090115135542.GI3199@fedora.yogi>
References: <20090115134347.45a88999@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115134347.45a88999@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 01:43:47PM +0100, Jean Delvare wrote:
> The i2c_device_id list is supposed to be zero-terminated.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Balaji Rao <balajirrao@openmoko.org>
> Cc: Samuel Ortiz <sameo@openedhand.com>
> ---
> As a side note, I am currious why you set the driver_data to 0x73 and
> then never use it...
> 

Hum, now I don't recall why I had then put it. Anyway, I'll send a patch to get
rid of it.

Thanks for your patch.

	- Balaji
