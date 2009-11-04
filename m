Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZKDRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZKDRKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbZKDRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:10:00 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:41878 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103AbZKDRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:09:59 -0500
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 12:09:59 EST
Date: Wed, 4 Nov 2009 17:40:02 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "Ryan C. Gordon" <icculus@icculus.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: package managers [was: FatELF patches...]
In-Reply-To: <alpine.OSX.1.10.0911012023020.55434@caridad.local>
Message-ID: <Pine.LNX.4.64.0911041710530.2927@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
 <alpine.OSX.1.10.0911011540400.53392@caridad.local>
 <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911012023020.55434@caridad.local>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Package managers are a _fantastic_ invention. They are a killer feature 
> over other operating systems, including ones people pay way too much money 
> to use.

No, package managers are evil feature that suppresses third party software 
and kills Linux success on desktop.

Package managers are super-easy to use --- but only as long as the package 
exists. No developer can make a package for all versions of all 
distributions. No distribution can make a package for all versions of all 
Linux software. So, inevitably, there are holes in the
[distribution X software] matrix, where the package isn't available.

- With Windows installers (next - next - next - finish), even a 
  technically unskilled person can select which version of a given 
  software he wants to use. If the software doesn't work, he can simply 
  uninstall it and try another version.

- With Linux package managers, the user is stuck with the software and 
  version shipped by the distribution. If he wants to install anything 
  newer or older, it turns into black magic and the typical desktop user 
  (non-hacker) can't do it.

- For non-technical user who can't compile, getting newer software for 
  Linux means reinstalling the whole distribution to a newer version. So, 
  "upgrade one program" translates into "upgrade all programs" (that will 
  bring many changes that the user didn't want and new bugs)


Let me say that instead of making a single binary for multiple 
architectures, you should concentrate on developing a method to make a 
single binary that works on all installations on one architecture :)

Mikulas
