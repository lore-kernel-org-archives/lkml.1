Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYJPS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYJPS5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJPS5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:57:25 -0400
Received: from willie.n0ano.com ([64.66.241.76]:33498 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751142AbYJPS5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:57:25 -0400
From: n0ano@n0ano.com
Date: Thu, 16 Oct 2008 12:57:05 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: n0ano@n0ano.com, Paul Bolle <pebolle@tiscali.nl>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081016185705.GF14490@xolotl.n0ano.com>
References: <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com> <48F785B0.7000008@kernel.org> <20081016182556.GE14490@xolotl.n0ano.com> <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:30:17AM -0700, Yinghai Lu wrote:
>... 
> but if someone don't need the switch from early console to normal console...
> 

Back to my original point, why would someone want just the
early console output on serial but not want the normal console
on serial?  I can't think of any use case where this makes
sense.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
