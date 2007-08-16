Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbXHPPsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbXHPPsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbXHPPsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:48:23 -0400
Received: from webmailfront01.ispgateway.de ([80.67.16.111]:53304 "EHLO
	webmailfront01.ispgateway.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbXHPPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:48:22 -0400
Message-ID: <20070816174510.6o8cray64g8kosos@webmail.df.eu>
Date: Thu, 16 Aug 2007 17:45:10 +0200
From: Clemens Ladisch <clemens@ladisch.de>
To: David Griffith <dgriffi@cs.csubak.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MOTU Fastlane USB MIDI interface
References: <Pine.GSO.4.55.0708100242000.25856@helios.cs.csubak.edu>
	<20070816093703.sndy0gg44gk0o0ko@webmail.df.eu>
	<Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
In-Reply-To: <Pine.GSO.4.55.0708160308450.24052@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: domainFACTORY
X-Originating-IP: 213.238.46.206
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Griffith wrote:
> Checking further, I've never been able to
> get midi to work with kernels 2.6.18 and later.

Please try "amidi -d -p virtual" and playing a .mid file to this port with
aplaymidi.


Regards,
Clemens

