Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbYCGR5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbYCGR5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYCGR5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:57:36 -0500
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:48313 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212AbYCGR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:57:35 -0500
X-YMail-OSG: 5.YKI6YVM1mUH1BNVHKvvAQK.Y3OMWRXODx2dDgpiuj1RvT8kbVKFXZCcsCpCki0Shiv17hI2Q--
X-RocketYMMF: rancidfat
Date: Fri, 7 Mar 2008 09:57:34 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
To: "Serge E. Hallyn" <serue@us.ibm.com>, Greg KH <greg@kroah.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com
In-Reply-To: <20080307173542.GA2552@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <757539.74589.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> ...
> 
> Until user namespaces are complete, selinux seems the only good solution
> to offer isolation.

Smack does it better and cheaper. (Unless you define good==selinux)
(insert smiley)



Casey Schaufler
casey@schaufler-ca.com
