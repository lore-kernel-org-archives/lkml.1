Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYGBLya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYGBLya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYGBLyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:54:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46148 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYGBLyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:54:20 -0400
To: sds@tycho.nsa.gov
CC: jmorris@namei.org, miklos@szeredi.hu, jjohansen@suse.de,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
In-reply-to: <1214999316.22447.240.camel@moss-spartans.epoch.ncsc.mil>
	(message from Stephen Smalley on Wed, 02 Jul 2008 07:48:36 -0400)
Subject: Re: [patch] security: fix dummy xattr functions
References: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021604120.26138@us.intercode.com.au>
	 <E1KDwg7-0007OX-5D@pomaz-ex.szeredi.hu>
	 <Xine.LNX.4.64.0807021906350.26138@us.intercode.com.au> <1214999316.22447.240.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <E1KE0ub-00087c-Ek@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 13:54:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008, Stephen Smalley wrote:
> As discussed elsewhere, the dummy module just needs to die, and
> capability needs to become the default module.

How hard would that be to do in your opinion?

It would help some if we didn't have to update the dummy module with
the changes required by apparmor.

Thanks,
Miklos
