Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXJBOSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXJBOSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJBOSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:18:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:35029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXJBOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:18:15 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] mark read_crX() asm code as volatile
Date: Tue, 2 Oct 2007 16:17:44 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
References: <470250E0.5090706@openvz.org>
In-Reply-To: <470250E0.5090706@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021617.44901.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2007 16:08:32 Kirill Korotaev wrote:
> Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from gentoo)
> can generate incorrect code with read_crX()/write_crX() functions mix up,
> due to cached results of read_crX().

added thanks

-Andi



