Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbZLQGv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbZLQGv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111AbZLQGvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:51:53 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57207 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZLQGvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:51:52 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKxjKUurR7H+/2dsb2JhbAC+SpcJhC0E
X-IronPort-AV: E=Sophos;i="4.47,410,1257120000"; 
   d="scan'208";a="451153248"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Michal Marek <mmarek@suse.cz>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>
	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>
	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com>
	<aday6l25gnm.fsf@roland-alpha.cisco.com> <4B29BFE8.1000502@zytor.com>
	<4B29C652.5080803@redhat.com> <4B29C661.6090800@zytor.com>
	<4B29CA73.4050005@redhat.com> <4B29CADE.8020905@zytor.com>
	<4B29CDC6.7040501@redhat.com> <4B29CF16.6060206@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 22:51:51 -0800
In-Reply-To: <4B29CF16.6060206@zytor.com> (H. Peter Anvin's message of "Wed,
	16 Dec 2009 22:26:30 -0800")
Message-ID: <adapr6e5bzs.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 06:51:51.0940 (UTC) FILETIME=[69B28C40:01CA7EE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Roland, Masami, Sam: can I add your respective Acked-by:?

Yes, please.
