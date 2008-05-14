Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYENVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYENVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYENVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:16:19 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:34846 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYENVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I4dnzCuGlat69ODzbkrAI8rGLTVm0bP3I6e2b/sgMtdRnh0m0o3sA6R6X/1rtxeJ7ibrp4Eow3PNAEd73sJGpG46EXp1I7RpkuC1PuQ4UWZYHq40R3qozBWEGiPDu0RnT0NklLkGFsJmHKhdnZyvk+1E0npUXT2dUX5azhddnUI=
Message-ID: <dd18b0c30805141416i420e8f1xbd8ecb3eac8f419e@mail.gmail.com>
Date: Wed, 14 May 2008 21:16:17 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: startx results in a blank screen
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I've compiled the latest git 2.6.26-rc2-**  and really like
what I see and feel(heat and noise) the problem I have is I'm forced
to use
 3rd party video drivers for dri : - (
 So with this in mind I'm trying to compile my video card module, and
am confused is to as or why startx results in a blank screen!!
 I've reverted drm and agpgart, and also tried to convert the video
module to use drm_minor(drmP.h), but still the same results,
 Where in the kernel might I find some useful info on why startx
results with a blank screen?
 looking at Xorg.0.log I'm seeing a stop at drmGetBusid''
 regards;

-- 
Justin P. Mattock
