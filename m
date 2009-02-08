Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbZBHCIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbZBHCIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 21:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZBHCId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 21:08:33 -0500
Received: from solo.fdn.fr ([80.67.169.19]:55541 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZBHCId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 21:08:33 -0500
Date: Sun, 8 Feb 2009 03:08:28 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kmh@nerdshack.com, linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de,
       lermen@fgan.de, davej@redhat.com, cebbert@redhat.com
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
Message-ID: <20090208020828.GB11308@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, kmh@nerdshack.com,
	linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de,
	lermen@fgan.de, davej@redhat.com, cebbert@redhat.com
References: <200712022336.SAA12095@granite.sover.net> <4977AB27.8080608@zytor.com> <20090121234347.GI5237@const.famille.thibault.fr> <4977BAC2.3060009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4977BAC2.3060009@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Wed 21 Jan 2009 16:16:02 -0800, a écrit :
> Samuel Thibault wrote:
> >>
> >>Unfortunately LOADLIN hasn't been updated for a very long time, and 
> >>there doesn't seem to be much interest in maintaining it.
> >
> >I've fixed loadlin in debian and actually plan to maintain it upstream.
> >I had to patch it quite a bit to make it compilable by yasm, but it can
> >now boot recent big kernels & initrds.
> >
> 
> Excellent news!  Is there a new upstream location (or do you need one)?

Here it is:

http://youpibouh.thefreecat.org/loadlin/

Samuel
