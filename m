Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXCDPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXCDPNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 10:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXCDPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 10:13:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXCDPNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 10:13:35 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070304041111.1d2774e7.akpm@linux-foundation.org> 
References: <20070304041111.1d2774e7.akpm@linux-foundation.org>  <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [Re: 2.6.21-rc2-mm1] #error no ROMFS backing store interface configured 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Sun, 04 Mar 2007 15:11:09 +0000
Message-ID: <14778.1173021069@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So we require that one of these be enabled if ROMFS.

At least one, yes.  Both can be enabled.  I don't know how to do it though.

David
