Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXGYO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXGYO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbXGYO7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:59:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:58156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbXGYO7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:59:08 -0400
From: Andi Kleen <ak@suse.de>
To: Kirill Korotaev <dev@openvz.org>
Subject: Re: i386-show-unhandled-signals-v3
Date: Wed, 25 Jul 2007 16:57:43 +0200
User-Agent: KMail/1.9.1
Cc: Masoud Asgharifard Sharbiani <masouds@google.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070718154759.GA26425@google.com> <46A76210.5020903@openvz.org>
In-Reply-To: <46A76210.5020903@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707251657.44217.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 16:45, Kirill Korotaev wrote:
> plz don't enable it by default... :/
> any user can spam syslog with these messages and if syslog is run as root
> can take the whole diskspace...

There are plenty of other ways to cause syslog messages anyways; this argument 
is 100% bogus.

-Andi
