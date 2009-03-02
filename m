Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZCBVd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZCBVd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZCBVdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:33:18 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:49845 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbZCBVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:33:17 -0500
Date: Mon, 2 Mar 2009 22:36:12 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sis190 issue
Message-ID: <20090302213611.GA19867@electric-eye.fr.zoreil.com>
References: <49ABFFCF.5090106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ABFFCF.5090106@gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrico Tagliavini <enrico.tagliavini@gmail.com> :
[...]
> With recent kernel >=2.6.27 i can't make large file transfert (via any
> protocol) with my local server anymore. The file transfer begin and after some
> seconds (sometimes minutes) it hangs on and i can't connect to my home server
> anymore even if i reboot my pc! But internet still works (i can connect to my
> home server using external ip, but not with local one).

Summary: your sis190 based client can transfer through nfs as long as
it is using a 2.6.26 kernel but it does not work with 2.6.27, right ?

-- 
Ueimor
