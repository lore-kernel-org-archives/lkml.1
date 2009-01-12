Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZALS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZALS5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZALS5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:57:43 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:44676 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753265AbZALS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:57:42 -0500
Date: Mon, 12 Jan 2009 18:57:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: .config - is the time really necessary
Message-ID: <20090112185739.GQ12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 3 of the .config files has the current date in it. Is this
information of any use to anyone? It makes life difficult when
producing series of patches that touches a defconfig, as you end
up with conflicts if you go back and change/remove/add one to the
series.

Would people object to the time/date being removed from the .config
file?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
