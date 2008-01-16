Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYAPVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYAPVb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYAPVax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:30:53 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46235 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYAPVaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:30:52 -0500
Date: Wed, 16 Jan 2008 22:30:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts: minor decodecode update
Message-ID: <20080116213058.GA31203@uranus.ravnborg.org>
References: <20080114151831.a5ff7d7a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114151831.a5ff7d7a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 03:18:31PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Remove the tmp file when exiting.  Noticed by Arjan van de Ven.
> Catch mktemp failure and exit with message.
> Trap kill or other signals and exit cleanly.

Applied,

	Sam
