Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYAHOyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYAHOyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYAHOyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:54:38 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53456 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbYAHOyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:54:37 -0500
Date: Tue, 8 Jan 2008 17:53:40 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH -mm 2/4] hifn_795x: fixup container_of() usage
Message-ID: <20080108145340.GA1383@2ka.mipt.ru>
References: <20080108084434.GB6209@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108084434.GB6209@localhost.sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Jan 08, 2008 at 11:44:34AM +0300, Alexey Dobriyan (adobriyan@sw.ru) wrote:
> [PATCH -mm 2/4] hifn_795x: fixup container_of() usage
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Well, I have no problem with the patch, although do not see any gain
in it :)
I usually prefer to call members the same in container usage, since I
always forget where each one should be placed.

-- 
	Evgeniy Polyakov
