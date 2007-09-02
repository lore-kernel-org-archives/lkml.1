Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbXIBSXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbXIBSXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXIBSXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:23:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:49842 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbXIBSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=epgIBOZgEimhr6Mk8gp4FD6c2PscXE35bLPTgqk4nohBXDZ+poUxe+mXmfFqIK9LSEtkZXRQahjb874d3cSXGzbzk5zq3dk0cA26QJc+Pyrh7E2Vc03z5gTNmTBCqOiSuJlSLQwqysnWhsIdVSyo7MV3Lv0nmllDLniN2Iu/xYY=
Message-ID: <7579f7fb0709021123p7088ec41m5b688f527ba46d13@mail.gmail.com>
Date: Sun, 2 Sep 2007 11:23:11 -0700
From: "Matthew Jacob" <lydianconcepts@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Fwd: That whole "Linux stealing our code" thing
In-Reply-To: <Pine.LNX.4.64.0709021754250.6772@condmat1.ciencias.uniovi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	 <20070902113638.78fbd202@the-village.bc.nu>
	 <Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
	 <20070902115041.GM16016@stusta.de>
	 <Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
	 <20070902134612.28a88761@the-village.bc.nu>
	 <Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
	 <m3642txj91.fsf@maximus.localdomain> <46DAC482.5090107@garzik.org>
	 <Pine.LNX.4.64.0709021754250.6772@condmat1.ciencias.uniovi.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This has been pretty interesting for me to watch as I distribute my
isp driver under a dual license (at least the portions of it which are
common with the *BSD and Solaris ports)  that is almost identical to
Sam's verbiage.

I'll admit that I hadn't thought about whether redistribution included
the ability to modify the header (and thus the text of the licensing
as I had written) or not. On balance I'd say I believe that the
arguments for, on redistribution, picking one or the other license
makes sense and honored my general intent.

This allows people who modify the code (and presumably improve it) a
"chef's choice" based on where they're serving the meal.

IANAL, but I believe that none of this keeps me from continuing to put
a dual license on stuff I leave up for distribution, or changing that
to restricting the code to Martian Triathalon winners or what have
you.
