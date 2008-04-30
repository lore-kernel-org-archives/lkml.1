Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbYD3Ovj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbYD3Ovj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbYD3OvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:51:15 -0400
Received: from ms.trustica.cz ([82.208.32.68]:41345 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbYD3OvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:51:13 -0400
Message-ID: <48188753.40305@assembler.cz>
Date: Wed, 30 Apr 2008 16:50:59 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Jean Delvare <khali@linux-fr.org>, Matthew <jackdachef@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, trenn@suse.de,
       Kasper Sandberg <lkml@metanurb.dk>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com> <200804182151.49021.lenb@kernel.org> <200804231143.10875.maximlevitsky@gmail.com> <1209406784.11608.15.camel@localhost> <1209474423.1784.837.camel@queen.suse.de> <20080429170824.09540206@hyperion.delvare> <48179DB4.8040701@assembler.cz> <e85b9d30804291558r4051f1bbm9256aa2af2d86b6c@mail.gmail.com> <20080430081035.2e789a50@hyperion.delvare> <20080430144655.GB3543@khazad-dum.debian.net>
In-Reply-To: <20080430144655.GB3543@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> but like lm_sensors's output states - it's not bad until  I / we're
>>> getting temperatures from 85°C (?) [in this particular case], ...
>> If I remember correctly, at 84°C your CPU will start to throttle, at
>> 100°C it will shut down. You still have 24°C before the former happens,
>> so it should be OK.

The high limit is when the all fans should go max. Throttle is at crit.

Rudolf
