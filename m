Return-Path: <linux-kernel-owner+w=401wt.eu-S1763448AbYB0I3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763448AbYB0I3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 03:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYB0I3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 03:29:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:41534 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYB0I3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 03:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mdutaExW/Z5aAWynNH4m2BPbDPPNEsbvMvD5BBQUGq71KhhnGcIUdnV0qKdbMLUoi7I+myKNQcQfheNboCksArQhiLHsI4H+kUCIkDH2M+9ehcQMnDLotgdqzc3W1ULRY4Sbq8RNwAKV79NGxql8MYNF6g1WZeDu1PuA9+AOCLk=
Message-ID: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>
Date: Wed, 27 Feb 2008 09:29:31 +0100
From: drago01 <drago01@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: Reexport init_mm ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
init_mm is no longer exported in 2.6.25, because there are no in tree
modules that use it.
But the closed sources nvidia drivers are using it.
Is it possible to reexport this symbol to let the driver work with this kernel?

Please CC me when repyling.
