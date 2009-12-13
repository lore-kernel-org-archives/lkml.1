Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZLMPiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZLMPiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 10:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZLMPip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 10:38:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:18693 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753540AbZLMPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 10:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=IDlEjk0VxaOrzUe7wkJ618z+/X/cOSGl6WV/Ypw/C+KeLwBSdvJuQGh/2gt9pqW3Iu
         ce6OonZ6yYHslGBJazSLGLksoHZnRXBPsjH/Zf1/Tz7WnmCeysN5irMUprvY3wzO8lJj
         95P9zIeSjJY+E9Y4fTy+pDqJAv04PbuxHgDcQ=
From: Diego Calleja <diegocg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Convert Documentation/ to asciidoc?
Date: Sun, 13 Dec 2009 16:38:55 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32; KDE/4.3.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912131638.55549.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git uses asciidoc, tools/perf/Documentation uses asciidoc... It seems
a good fit for Documentation/. Is there any objection against it?
