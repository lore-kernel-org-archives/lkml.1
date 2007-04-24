Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXDXLyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXDXLyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 07:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030370AbXDXLyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 07:54:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224AbXDXLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 07:54:48 -0400
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: NonExecutable Bit in 32Bit
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Apr 2007 14:52:41 +0200
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
Message-ID: <p73wt022aue.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Cestonaro, Thilo \(external\)"    <Thilo.Cestonaro.external@fujitsu-siemens.com> writes:


> is it right, that the NX Bit is not used under i386-Arch but under x86_64-Arch?

It is wrong.

-Andi
