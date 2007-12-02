Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXLBAfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXLBAfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXLBAfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:35:08 -0500
Received: from main.gmane.org ([80.91.229.2]:54798 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbXLBAfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:35:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
Date: Sat, 1 Dec 2007 16:30:35 -0800
Organization: Linux Foundation
Message-ID: <20071201163035.321fd554@freepuppy.rosehill>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <20071201111736.297dd99a@freepuppy.rosehill>
X-Newsreader: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Cc: netdev@vger.kernel.org, containers@lists.osdl.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 11:17:36 -0800
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> Then init_net needs to be not GPL limited. Sorry, we need to allow
> non GPL network drivers.  There is a fine line between keeping the
> binary seething masses from accessing random kernel functions, and allowing
> reasonable (but still non GPL) things like ndiswrapper to use network
> device interface.
> 
I spoke too soon earlier, ndiswrapper builds and loads against current
2.6.24-rc3. Vmware and proprietary VPN software probably do not. Once again I don't
give a damn, but the enterprise distro vendors certainly care.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

