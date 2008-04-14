Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbYDNQ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbYDNQ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbYDNQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:29:12 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60856 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758346AbYDNQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:29:11 -0400
Date: Mon, 14 Apr 2008 12:29:11 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marc Perkel <mperkel@yahoo.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
Message-ID: <20080414162911.GC7387@csclub.uwaterloo.ca>
References: <47FFD3F3.50107@redhat.com> <821384.64293.qm@web52504.mail.re2.yahoo.com> <20080411213843.GH2160@csclub.uwaterloo.ca> <4802608A.3040901@zytor.com> <20080414151222.GF7385@csclub.uwaterloo.ca> <4803851A.8090206@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4803851A.8090206@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:23:54AM -0700, H. Peter Anvin wrote:
> That, too, is clearly unrealistic, or NTP would be useless except on 
> dedicated systems.

Well I have certainly encountered quite a few systems now where ntp
never converged if spread spectrum was enabled in the BIOS.  Disabling
it on the other hand made ntp have no issues converging just fine.

-- 
Len Sorensen
