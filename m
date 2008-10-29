Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYJ2Mx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYJ2Mx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYJ2Mxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:53:46 -0400
Received: from gw.goop.org ([64.81.55.164]:42275 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYJ2Mxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:53:45 -0400
Message-ID: <49085CD5.7060703@goop.org>
Date: Wed, 29 Oct 2008 23:53:41 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] x86: Use new gate_struct for gate_desc
References: <> <1224904532-9586-1-git-send-email-ice799@gmail.com> <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com> <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
In-Reply-To: <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> Change the gate_desc typedef to use the new gate_struct.
>   

Blerk, yes.  I'd really prefer these typedefs to use the _t convention.

    J
