Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbXHQGRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbXHQGRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbXHQGRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:17:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44713 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbXHQGRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:17:34 -0400
Message-Id: <1187331453.13767.1205847147@webmail.messagingengine.com>
X-Sasl-Enc: cdEMJ26YM7qVl3RSKCETeO/N4S7AnK8Het350Vbu0fRo 1187331453
From: "Clemens Ladisch" <clemens@ladisch.de>
To: "David Griffith" <dgriffi@cs.csubak.edu>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
   <20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
   <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
   <20070816174510.6o8cray64g8kosos@webmail.df.eu>
   <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
Subject: Re: MOTU Fastlane USB MIDI interface
In-Reply-To: <Pine.GSO.4.55.0708161417270.9354@helios.cs.csubak.edu>
Date: Fri, 17 Aug 2007 08:17:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Griffith wrote:
> On Thu, 16 Aug 2007, Clemens Ladisch wrote:
> > Please try "amidi -d -p virtual" and playing a .mid file to this port with
> > aplaymidi.
> 
> $ aplaymidi -p "virtual" castle2.mid
> Invalid port virtual - No such file or directory

Sorry, the name of the correspondig sequencer port is different,
probably "128:0"; see the output of "aplaymidi -l".


Regards,
Clemens
