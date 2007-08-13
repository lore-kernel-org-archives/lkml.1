Return-Path: <linux-kernel-owner+w=401wt.eu-S947658AbXHMOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947658AbXHMOyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030385AbXHMMRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:17:10 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34201 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968071AbXHMMRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:17:05 -0400
Date: Mon, 13 Aug 2007 14:17:01 +0200
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regression from 2.6.23-rc2 to -rc3 BAT missing
Message-ID: <20070813121701.GA25771@gamma.logic.tuwien.ac.at>
References: <20070813094354.GA4881@gamma.logic.tuwien.ac.at> <46C02D52.40002@gmail.com> <20070813101009.GB4881@gamma.logic.tuwien.ac.at> <46C030CE.2000406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C030CE.2000406@gmail.com>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Alexey Starikovskiy wrote:
> Please check if the attached patch helps.

No, didn't help, same behaviour.

Do you need dsdt or anything else?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
NACTION (n.)
The 'n' with which cheap advertising copywriters replace the word
'and' (as in 'fish 'n' chips', 'mix 'n' match', 'assault 'n'
battery'), in the mistaken belief that this is in some way chummy or
endearing.
			--- Douglas Adams, The Meaning of Liff
