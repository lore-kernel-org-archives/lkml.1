Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZBJWTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZBJWTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBJWSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:18:55 -0500
Received: from ozlabs.org ([203.10.76.45]:42628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbZBJWSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:18:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/3] use the new request_module_nowait() in the hid driver
Date: Wed, 11 Feb 2009 08:48:52 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
References: <20090208104201.6124ab6a@infradead.org> <20090208104240.3405903f@infradead.org> <alpine.LNX.1.10.0902101822280.11630@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0902101822280.11630@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902110848.52551.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009 03:53:29 Jiri Kosina wrote:
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Rusty, could you please take this altogether with the patch introducing 
> request_module_nowait() itself?

Yep, done!

Thanks,
Rusty.
