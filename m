Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZAFSd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZAFSd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZAFSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:33:16 -0500
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:57958
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZAFSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:33:14 -0500
Subject: Re: [PATCH 2/2] input: Add a detailed multi-touch finger data
	report protocol (rev2)
From: Jim Gettys <jg@laptop.org>
Reply-To: jg@laptop.org
To: Henrik Rydberg <rydberg@euromail.se>, jkosina@suse.cz,
       Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Peter Hutterer <peter.hutterer@who-t.net>, linux-kernel@vger.kernel.org
In-Reply-To: <495804B1.10300@euromail.se>
References: <495804B1.10300@euromail.se>
Content-Type: text/plain
Organization: One Laptop Per Child
Date: Tue, 06 Jan 2009 13:32:49 -0500
Message-Id: <1231266769.8379.79.camel@jg-vaio>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a remaining question: how/whether to implement this interface
in USB HID.....

On page 9 of the document you'll find at:
http://www.microsoft.com/whdc/device/input/DigitizerDrvs_touch.mspx

Microsoft is claiming in that document of December 8 they are proposing
the interfaces in the document to the USB IF organization, and that
hardware vendors for Windows 7 should follow that spec.

Jiri, Greg:

1) Does anyone know if Microsoft has actually made the proposal to the
USB IF?  Is there anyone in the community watching/commenting on USB IF
proposals?

2) do you want generic USB HID patches or do you want to, for now,
confine these to USB device specific drivers as much as possible?
                          - Jim

-- 
Jim Gettys <jg@laptop.org>
One Laptop Per Child

