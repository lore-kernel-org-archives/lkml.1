Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbYJNFDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbYJNFDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYJNFDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:03:01 -0400
Received: from usul.saidi.cx ([204.11.33.34]:49233 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751843AbYJNFDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:03:00 -0400
X-Greylist: delayed 2885 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 01:03:00 EDT
Message-ID: <48F41CB4.6040207@overt.org>
Date: Mon, 13 Oct 2008 21:14:44 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: Refactor evdev 32bit compat to be shareable	with
 uinput
References: <471118B5.7050503@overt.org> <20081008011543.GA2813@amd.corenet.prv> <20081009053642.GA10021@amd.corenet.prv>
In-Reply-To: <20081009053642.GA10021@amd.corenet.prv>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tue, Oct 07, 2008 at 09:15:43PM -0400, Dmitry Torokhov wrote:
>> As I promised, here is the
>> revision of your patch that I would like to commit to the next branch
>> and I would appreciate if you could give it a try.
> 
> Argh, not sure where what I sent came from but this one should at least
> compile...
> 

Compiles and works as advertised. Thanks!

--phil
