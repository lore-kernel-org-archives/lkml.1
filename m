Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZGHUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZGHUbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbZGHUbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:31:03 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:29836 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZGHUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:31:02 -0400
Date: Wed, 8 Jul 2009 13:31:01 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Laurent Bigonville <l.bigonville@edpnet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sinosun TPM support
Message-ID: <20090708203101.GB6060@hexapodia.org>
References: <20090707140718.4337498b@edoras.bigon.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707140718.4337498b@edoras.bigon.be>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:07:18PM +0200, Laurent Bigonville wrote:
> Does anyone know if there is any support in the kernel for Sinosun TPM
> modules as my futur motherboard will have that chip.

If it conforms to the TPM TIS 1.2 specification, it should work with
tpm_tis.ko.

-andy
