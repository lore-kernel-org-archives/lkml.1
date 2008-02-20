Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbYBTSP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbYBTSP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbYBTSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:15:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:21691 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140AbYBTSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eGCM1gP1yBo7gCEa7t1sDlxFBkqd7IT0pqDh841wXmw1N55621+U55zKmAfvgpgs1nZqjk5GhLH2MVPH6rqw7lh4X4JAfBi2y2nor33mjqWwsFL7IkGQId6Z15K2ujDlY6iIBAkrp751gqmcrUZ0UJsmiNclcQHW6HF6ovXrS7E=
Date: Wed, 20 Feb 2008 21:15:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220181500.GC6733@cvg>
References: <20080220175145.GA6733@cvg> <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com> <20080220131442.GA18790@uranus.ravnborg.org> <11226.1203531195@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11226.1203531195@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Howells - Wed, Feb 20, 2008 at 06:13:15PM +0000]
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Sam, maybe we should just eliminate this section at least for FRV?
| 
| You should have a patch in your inbox to do just that.
| 
| David
| 

Thanks David! I've got them all.
I think Sam will take care of them to be included in mainline.
Thanks.

		- Cyrill -
