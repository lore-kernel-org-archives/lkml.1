Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZEYJbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZEYJbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZEYJbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:31:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:48737 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZEYJbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:31:08 -0400
Message-Id: <4A1A81770200007800002593@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 25 May 2009 10:31:03 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>, "Tomasz Chmielewski" <mangoo@wpkg.org>
Cc: <mingo@elte.hu>, <jeremy@goop.org>, "Alan" <alan@lxorguk.ukuu.org.uk>,
       "Gerd Hoffmann" <kraxel@redhat.com>,
       "LKML" <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A1A59DD.7030101@wpkg.org>
 <20090525091530.GW846@one.firstfloor.org>
In-Reply-To: <20090525091530.GW846@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 25.05.09 11:15 >>>
>To my knowledge the only CPUs with broken PAT are some very old Pentium
>Pros dating from back the time when PAT was new and noone used it.
>On those it should be disabled or the high bits not used.

??? See PentiumIII erratum E27.

Jan

