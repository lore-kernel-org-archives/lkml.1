Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0CLHWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 02:22:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57385 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab0CLHWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 02:22:36 -0500
Message-ID: <4B99EBB9.5000508@canonical.com>
Date: Fri, 12 Mar 2010 08:22:33 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: gleb@redhat.com, avi@redhat.com, gregkh@suse.de, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: patch kvm-x86-emulator-add-group8-instruction-decoding.patch
 added to 2.6.32-stable tree
References: <12683548383025@site>
In-Reply-To: <12683548383025@site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I am currently working on getting the whole series of kvm patches marked for
stable backported to 2.6.32. You could pick those from

git://kernel.ubuntu.com/smb/linux-2.6.32.y.git kvm

Currently there is one patch on the HEAD which is fixing a regression for AMD
hosts. That is not upstream, yet. (needed for the patch fixing memory access).

Stefan


