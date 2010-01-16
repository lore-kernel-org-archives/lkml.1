Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0APLQ4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204Ab0APLQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:16:54 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:52098 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0APLQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:16:53 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jan 2010 06:16:53 EST
Message-ID: <cone.1263640262.140101.28399.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Coretemp Atom 330, strange temperatures
Date: Sat, 16 Jan 2010 12:11:02 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rudolf, Hi Huaxu,

I've got an Asrock Ion 330 machine with Atom 330 processor, running 
2.6.32.3 kernel. When loading coretemp it shows strange temperatures, like 
this:
Core0: 0.0 degree C
Core1: 16.0 degree C
Core2: 0.0 degree C
Core3: 15.0 degree C

Is there an offset missing? When touching the cooler it feels like 40 degree ore something.
Is this a known problem? Is there already a fix?

thanks for your time and kind regards,
--peter
