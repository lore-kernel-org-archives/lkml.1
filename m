Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXFRRrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXFRRrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXFRRqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:46:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:52725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXFRRqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:46:53 -0400
Message-ID: <4676C4D8.1030404@zytor.com>
Date: Mon, 18 Jun 2007 10:46:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org>
In-Reply-To: <20070618172955.GB24189@thunk.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> As I mentioned in my Linux.conf.au presentation a year and a half ago,
> the main use of Streams in Windows to date has been for system
> crackers to hide trojan horse code and rootkits so that system
> administrators couldn't find them.  :-)
> 

But... that's an essential feature in Windows!  Otherwise, how would
Microsoft produce a RKDK (Rootkit development kit) to sell to Sony?

	-hpa
