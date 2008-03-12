Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYCLN41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYCLN41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYCLN4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:56:16 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35888 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYCLN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:56:15 -0400
Date: Wed, 12 Mar 2008 14:55:21 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080312135521.GE8141@ics.muni.cz>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080226184937.GA4280@ics.muni.cz> <20080304194513.GY6704@kernel.dk> <47CDBA74.5080304@gmail.com> <20080304211212.GD6704@kernel.dk> <47CDBE11.4010900@gmail.com> <20080312125912.GM17940@kernel.dk> <20080312131737.GA21290@khazad-dum.debian.net> <20080312132419.GN17940@kernel.dk> <20080312133529.GB21290@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080312133529.GB21290@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 12 Mar 2008 14:55:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:35:29AM -0300, Henrique de Moraes Holschuh wrote:
> You shouldn't need to do anything other than teach userspace to respond to
> them, as they generate the proper KEY_* events.  If you are giving the AML
> _OSI(Linux), at least...
> 
> But maybe looking at the keyboard output in console mode, to make triple
> sure the events ARE being sent over the KDC as they should, would be in
> order?

so, do I understand correctly that volume keys have been controlled by ACPI
and seemed to work independently on SW and now (exactly since when?) are
passed complety to the user space as key codes?

-- 
Luká¹ Hejtmánek
