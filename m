Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZLIUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZLIUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZLIUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:51:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:53096 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZLIUva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:51:30 -0500
Subject: Re: [RFC] doc/powerpc: try to explain why the interrupt numbers are off by 16
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20091206113247.GB9937@Chamillionaire.breakpoint.cc>
Date: Wed, 9 Dec 2009 14:51:10 -0600
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       Alemao <xcarandiru@gmail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B3B43F76-0971-4DFA-95E7-1A1D446A1535@kernel.crashing.org>
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com> <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com> <d970ff420909041229hb3aa96dya329e06ea56dd1ac@mail.gmail.com> <20090906110641.GA11350@Chamillionaire.breakpoint.cc> <20090909182857.GB8215@b07421-ec1.am.freescale.net> <20090910131544.GB23433@Chamillionaire.breakpoint.cc> <20090910222400.GB26587@Chamillionaire.breakpoint.cc> <4AA97D50.40209@freescale.com> <20091206113247.GB9937@Chamillionaire.breakpoint.cc>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 6, 2009, at 5:32 AM, Sebastian Andrzej Siewior wrote:

> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
> Documentation/powerpc/dts-bindings/fsl/mpic.txt |   42 +++++++++++++++++++++++
> 1 files changed, 42 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpic.txt

applied to next

- k