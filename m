Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXCRG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXCRG5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXCRG5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:57:21 -0400
Received: from main.gmane.org ([80.91.229.2]:53810 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXCRG5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:57:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Loading both the pata_atiixp and the ahci driver causes problems
Date: Sun, 18 Mar 2007 02:56:26 -0400
Organization: World Organi[sz]ation Of Broken Dreams
Message-ID: <45FCE29A.5040805@jonmasters.org>
References: <45F9C3F5.4070906@redhat.com> <45F9F5F0.3090508@jonmasters.org> <45FCD0FB.70507@gmail.com> <45FCDBFA.702@jonmasters.org> <45FCDE73.8090002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: linux-ide@vger.kernel.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
In-Reply-To: <45FCDE73.8090002@gmail.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> Please take a look at the JMB quirk in drivers/pci/quirks.c in the
> latest libata-dev#upstream tree for details.

For interest, I will, thanks for the info.

Jon.

