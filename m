Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZLKP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZLKP27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZLKP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:28:48 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59597 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758762AbZLKP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:28:44 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2009 10:28:44 EST
MIME-Version: 1.0
Date: Fri, 11 Dec 2009 17:21:00 +0200
Message-ID: <e50e54220912110721x3d3ffb4ard8f458923db005bc@mail.gmail.com>
Subject: Add missing header for HTC Dream framebuffer
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, Mures Andone <mures.andone@movial.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

I'm wondering what happened to the patch [1] that added
include/linux/msm_mdp.h? I would be very interested in having this
header at where it belongs, and think that since the merge window is
open now, it would be good time to get back to that patch. :)

Thanks,
Dmitri

[1] http://lkml.org/lkml/2009/10/28/348
