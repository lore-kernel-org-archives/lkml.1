Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYCODrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYCODrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYCODro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:47:44 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:35347 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYCODrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uxS8kpq3VL0eVDokkhc78awpGlm/wVHXaTADga5ols01aThSrt2nHGSLnpj6yOTzXruDBzgw5Cb92XZJwGFR/MMRhliIOmlh1IYLCsL/BanZZ2bK0DOsm599SVUifRBc3ky+dtMMHsj76A5HEH7vK4yBpAngAZjR00REd8fmZgc=
Message-ID: <6143341e0803142047r1a1ef0e9l89ac46231640fb35@mail.gmail.com>
Date: Sat, 15 Mar 2008 03:47:42 +0000
From: Lucas <canolucas@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Typo report (this doesn't affect the behaviour of the code since the line is commented)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be an "e" at the end of line 14 of /fs/ext4/mballoc.c
