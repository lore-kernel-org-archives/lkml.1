Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbXFUSa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbXFUSa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXFUSav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:30:51 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:54427 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXFUSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:30:50 -0400
Message-ID: <467AC3D3.8080405@mandic.com.br>
Date: Thu, 21 Jun 2007 15:30:43 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kitame@debian.org, joss@debian.org
Subject: gconfd messages about permissions in some positions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I don't understand this messages available in /var/log/messages about 
gconfd.

I don't use gnome (my desktop installed is KDE on Debian Etch, with 
tasks="standard, kde-desktop" in boot line of installer DVD).

======
gconfd (yamane-4120): GConf server is not in use, turn-off.
gconfd (yamane-4120): Finishing

gconfd (yamane-5230): starting (version 2.16.1), pid 5230 user 'yamane'

gconfd (yamane-5230): Address 
"xml:readonly:/etc/gconf/gconf.xml.mandatory" resolved from a config 
source with only read permissions in position 0

gconfd (yamane-5230): Address "xml:readwrite:/home/yamane/.gconf" 
resolved from a config source with write permissions in position 1

gconfd (yamane-5230): Address 
"xml:readonly:/etc/gconf/gconf.xml.defaults" resolved from a config 
source with only read permissions in position 2

gconfd (yamane-5230): Address 
"xml:readonly:/var/lib/gconf/debian.defaults" resolved from a config 
source with only read permissions in position 3

gconfd (yamane-5230): Address "xml:readonly:/var/lib/gconf/defaults" 
resolved from a config source with only read permissions in position 4
======

Best regards,
Renato S. Yamane
