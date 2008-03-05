Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbYCEX1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbYCEX1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbYCEX1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:27:01 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53951 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbYCEX1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:27:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CF2C08.5000609@s5r6.in-berlin.de>
Date: Thu, 06 Mar 2008 00:26:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Gabriel Paubert <paubert@iram.es>
CC: Jarod Wilson <jwilson@redhat.com>, benh@kernel.crashing.org,
       Kristian Hoegsberg <krh@bitplanet.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org> <200802272221.38985.jwilson@redhat.com> <1204179959.15052.372.camel@pasglop> <200802281342.06493.jwilson@redhat.com> <1204241162.15052.393.camel@pasglop> <47C79CB1.6050104@redhat.com> <20080303091927.GA27105@iram.es> <47CC0C95.1030709@s5r6.in-berlin.de> <20080305225902.GA27985@iram.es>
In-Reply-To: <20080305225902.GA27985@iram.es>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel Paubert wrote:
>>> I have a Pismo which I use on a virtually
>>> daily basis (and about to remove the last remnants of MacOS on it). 
>>> However I have disabled Firewire because it would not sleep and wake 
>>> up properly. 
...
> For now I have only tested the new stack with a 6 year old 1.8" disk
> and everything works, including suspend to RAM. The kernel is 2.6.25-rc4
> plus additional pull from linux1394-2.6.git: 2.6.25-rc4-00032-g8d36ba4.

That's great.  Thanks for testing.
-- 
Stefan Richter
-=====-==--- --== --==-
http://arcgraph.de/sr/
