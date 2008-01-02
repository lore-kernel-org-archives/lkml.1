Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYABCnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYABCnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYABCm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:42:57 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:56368 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbYABCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:42:56 -0500
Subject: Re: Get physical MAC address
From: Jon Masters <jonathan@jonmasters.org>
To: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 01 Jan 2008 21:42:18 -0500
Message-Id: <1199241738.3300.63.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-31 at 12:39 +0700, Theewara Vorakosit wrote:

> I get MAC address from ioctl. However, ifconfig can change this  MAC 
> address. Can I get a real physical MAC address of the NIC?

Forgive me reading into your mail...this smells a bit like some kind of
licensing/compliance thing. Just bear in mind that using the MAC to
verify the identity of a machine is utterly useless and pointless -
anyone can trivially fool your software[0] to see what it "wants".

Jon.

[0] We used to have to do far worse kludgery in college, in order to
prevent the silly powers that be who "banned" network cards other than
those made by one manufacturer from being used on their little network.


