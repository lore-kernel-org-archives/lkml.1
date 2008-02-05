Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYBEQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYBEQqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYBEQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:46:14 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:10296 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYBEQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PNaGE6yBAnT7oHWQnTv4HvoWTh3/FQr99c3ZH6ca+mbZ8OPcMkurV5zBU/yBjzhjqumkqk5wqVyIZykE6CfYMsBlXRmsQ53CQLJzwWmtx7tMhzVj65cYF+43MAYBZYsPceEWF7OtZTe3L9TcPaukY2vgYmMvjopRz1NB0qCirC8=
Message-ID: <3aa654a40802050846n6491b2c6kb2af34f54262273f@mail.gmail.com>
Date: Tue, 5 Feb 2008 08:46:08 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Robert Hancock" <hancockr@shaw.ca>,
       "Andrew Morton" <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       shaohua.li@intel.com, trenn@suse.de,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
In-Reply-To: <200802050003.32591.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no>
	 <200802041341.37313.bjorn.helgaas@hp.com>
	 <alpine.LFD.1.00.0802041300170.3034@hp.linux-foundation.org>
	 <200802050003.32591.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 11:03 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> Does anybody with this motherboard (or the Supermicro board with
> similar SATA problems) also have Windows on it?  I'm curious to
> see how Windows deals with this conflict, e.g., what shows up in
> the device manager?

Sorry, I don't own Windows.
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
