Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYGVKrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYGVKrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYGVKqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:46:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:34688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGVKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=DaEmaFNCZ/QMy3T+G3Z0Gy+91uwWzyvhghLZNtI8aQdDafgNo3+RAKNSpLaFg8GHzO
         f7iVsJ1KL40ZpdoEWih2/0tGftK6QK9ZzKE8UGlCOK0C3Z9RA5PDgnVY5B3gFCSgvsEU
         MBE2abUj+ie/FBdZN0xpstgBCD9cwDXbaRpRM=
Date: Tue, 22 Jul 2008 10:51:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, kaber@trash.net, mingo@elte.hu,
       ischram@telenet.be, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
	at 0000000000000370
Message-ID: <20080722105158.GA6024@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48857F74.2040406@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-07-2008 08:34, Larry Finger wrote:
...
>>> I used the davem patch, the second version of your first one, and 
>>> your second one. Both problems persist.

Could you send lockdep info after Patrick's "set lockdep classes"
patch?

Jarek P.
