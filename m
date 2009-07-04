Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZGDXpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZGDXpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 19:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZGDXpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 19:45:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZGDXpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 19:45:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 2/3] Trivial: fix typo in label name s/Platofrm_finish/Platform_finish/
Date: Sun, 5 Jul 2009 01:46:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org
References: <1246746815-12146-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1246746815-12146-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907050146.25108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 July 2009, Thadeu Lima de Souza Cascardo wrote:
> Although the same label name is used somewhere else in the file, this
> particular label was consistently typoed in all of its uses.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---

Thanks, the patch is now in the linux-next branch of the suspend-2.6 tree.

Best,
Rafael
