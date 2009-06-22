Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZFVQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZFVQrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbZFVQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:45:46 -0400
Received: from kroah.org ([198.145.64.141]:36382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034AbZFVQpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:45:45 -0400
Date: Mon, 22 Jun 2009 09:23:54 -0700
From: Greg KH <greg@kroah.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi: show qos AC parameters
Message-ID: <20090622162354.GA19945@kroah.com>
References: <200906152114.n5FLEDT3015406@hera.kernel.org> <20090621110727.74d95b28@infradead.org> <20090622024838.GB18153@kroah.com> <E9954878DD1FB34FAE5187FB88C58A3557072BE9@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3557072BE9@orsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 07:06:14AM -0700, Guy, Wey-Yi W wrote:
> Oh ok.
> I will submit the patch to fix this.

Also, all new sysfs files need an entry in Documentation/ABI/.

thanks,

greg k-h
